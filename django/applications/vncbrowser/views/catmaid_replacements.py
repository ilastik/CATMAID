from vncbrowser.models import Project, Stack, Class, ClassInstance
from vncbrowser.models import TreenodeClassInstance, ConnectorClassInstance
from vncbrowser.views import catmaid_login_optional, catmaid_login_required
from collections import defaultdict
from django.db import connection
import json
from django.http import HttpResponse, Http404

@catmaid_login_optional
def projects(request, logged_in_user=None):
    # This is somewhat ridiculous - four queries where one could be
    # used in raw SQL.  The problem here is chiefly that
    # 'select_related' in Django doesn't work through
    # ManyToManyFields.  Development versions of Django have
    # introduced prefetch_related, but this isn't in the stable
    # version that I'm using.  (Another way around this would be to
    # query on ProjectStack, but the legacy CATMAID schema doesn't
    # include a single-column primary key for that table.)

    stacks = dict((x.id, x) for x in Stack.objects.all())

    # Create a dictionary that maps from projects to stacks:
    c = connection.cursor() #@UndefinedVariable
    c.execute("SELECT project_id, stack_id FROM project_stack")
    project_to_stacks = defaultdict(list)
    for project_id, stack_id in c.fetchall():
        project_to_stacks[project_id].append(stacks[stack_id])

    # Find all the projects, and mark those that are editable from the
    # project_user table:
    if logged_in_user:
        projects = Project.objects.all()
        c.execute("SELECT project_id FROM project_user WHERE user_id = %s",
                  [logged_in_user.id])
        editable_projects = set(x[0] for x in c.fetchall())
    else:
        projects = Project.objects.filter(public=True)
        editable_projects = set([])

    # Find all the projects that are editable:
    catalogueable_projects = set(x.project.id for x in Class.objects.filter(class_name='driver_line').select_related('project'))

    # Create a dictionary with those results that we can output as JSON:
    result = {}
    for p in projects:
        if p.id not in project_to_stacks:
            continue
        stacks_dict = {}
        for s in project_to_stacks[p.id]:
            stacks_dict[s.id] = {
                'title': s.title,
                'comment': s.comment,
                'note': '',
                'action': 'javascript:openProjectStack(%d,%d)' % (p.id, s.id)}
        editable = p.id in editable_projects
        result[p.id] = {
            'title': p.title,
            'public_project': int(p.public),
            'editable': int(editable),
            'catalogue': int(p.id in catalogueable_projects),
            'note': '[ editable ]' if editable else '',
            'action': stacks_dict}
    return HttpResponse(json.dumps(result, sort_keys=True, indent=4), mimetype="text/json")

@catmaid_login_required
def labels_all(request, project_id=None, logged_in_user=None):
    qs = ClassInstance.objects.filter(
        class_column__class_name='label',
        project=project_id)
    return HttpResponse(json.dumps(list(x.name for x in qs)), mimetype="text/plain")

@catmaid_login_required
def labels_for_node(request, project_id=None, ntype=None, location_id=None, logged_in_user=None):
    if ntype == 'treenode':
        qs = TreenodeClassInstance.objects.filter(
            relation__relation_name='labeled_as',
            class_instance__class_column__class_name='label',
            treenode=location_id,
            project=project_id).select_related('class_instance')
    elif ntype == 'location' or ntype == 'connector':
        qs = ConnectorClassInstance.objects.filter(
            relation__relation_name='labeled_as',
            class_instance__class_column__class_name='label',
            connector=location_id,
            project=project_id).select_related('class_instance')
    else:
        raise Http404('Unknown node type: "%s"' % (ntype,))
    return HttpResponse(json.dumps(list(x.class_instance.name for x in qs)), mimetype="text/plain")

@catmaid_login_required
def labels_for_nodes(request, project_id=None, logged_in_user=None):
    nodes = [int(x, 10) for x in json.loads(request.POST['nods']).keys()]

    qs_treenodes = TreenodeClassInstance.objects.filter(
        relation__relation_name='labeled_as',
        class_instance__class_column__class_name='label',
        treenode__id__in=nodes,
        project=project_id).select_related('treenode', 'class_instance')

    qs_connectors = ConnectorClassInstance.objects.filter(
        relation__relation_name='labeled_as',
        class_instance__class_column__class_name='label',
        connector__id__in=nodes,
        project=project_id).select_related('connector', 'class_instance')

    result = defaultdict(list)

    for tci in qs_treenodes:
        result[tci.treenode.id].append(tci.class_instance.name)

    for cci in qs_connectors:
        result[cci.connector.id].append(cci.class_instance.name)

    return HttpResponse(json.dumps(result), mimetype="text/plain")