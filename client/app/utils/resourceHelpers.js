import { ROUTES } from 'containers/Shared/Routes/constants';

export function getFolderShowPath(folder) {
  if (folder == null)
    return null;

  if (folder.group_id)
    return ROUTES.group.resources.folders.show.path(folder.group_id, folder.id);
  if (folder.enterprise_id)
    return ROUTES.admin.manage.resources.folders.show.path(folder.id);

  return null;
}

export function getFolderIndexPathFromObject(folder) {
  if (folder.group_id)
    return ROUTES.group.resources.index.path(folder.group_id);
  if (folder.enterprise_id)
    return ROUTES.admin.manage.resources.index.path();

  return null;
}

export function getFolderIndexPathFromType(type, groupId = null) {
  if (type === 'group')
    return ROUTES.group.resources.index.path(groupId);
  if (type === 'admin')
    return ROUTES.admin.manage.resources.index.path();

  return null;
}

export function getFolderNewPathFromObject(folder) {
  if (folder.group_id)
    return {
      pathname: ROUTES.group.resources.folders.new.path(folder.group_id),
      fromFolder: {
        folder,
        action: 'new'
      }
    };
  if (folder.enterprise_id)
    return {
      pathname: ROUTES.admin.manage.resources.folders.new.path(),
      fromFolder: {
        folder,
        action: 'new'
      }
    };

  return null;
}

export function getFolderNewPathFromType(type, groupId = null) {
  if (type === 'group')
    return ROUTES.group.resources.folders.new.path(groupId);
  if (type === 'admin')
    return ROUTES.admin.manage.resources.folders.new.path();

  return null;
}

export function getFolderEditPath(folder) {
  if (folder == null)
    return null;
  if (folder.group_id)
    return ROUTES.group.resources.folders.edit.path(folder.group_id, folder.id);
  if (folder.enterprise_id)
    return ROUTES.admin.manage.resources.folders.edit.path(folder.id);

  return null;
}

export function getParentPage(folder) {
  if (folder == null)
    return null;
  if (folder.parent)
    return getFolderShowPath(folder.parent);
  return getFolderIndexPath(folder);
}

export function getFolderNewPath(arg1, arg2 = null) {
  if (arg1 == null)
    return null;
  switch (typeof (arg1)) {
    case 'string':
      return getFolderNewPathFromType(arg1, arg2);
    case 'object':
      return getFolderNewPathFromObject(arg1);
    default:
      return null;
  }
}

export function getFolderIndexPath(arg1, arg2 = null) {
  if (arg1 == null)
    return null;
  switch (typeof (arg1)) {
    case 'string':
      return getFolderIndexPathFromType(arg1, arg2);
    case 'object':
      return getFolderIndexPathFromObject(arg1);
    default:
      return null;
  }
}

export function getResourceNewPath(folder) {
  if (folder == null)
    return null;

  if (folder.group_id)
    return ROUTES.group.resources.new.path(folder.group_id, folder.id);
  if (folder.enterprise_id)
    return ROUTES.admin.manage.resources.new.path(folder.id);

  return null;
}

export function getResourceEditPath(folder, resource) {
  if (folder == null || resource == null)
    return null;

  if (folder.group_id)
    return ROUTES.group.resources.edit.path(folder.group_id, folder.id, resource.id);
  if (folder.enterprise_id)
    return ROUTES.admin.manage.resources.edit.path(folder.id, resource.id);

  return null;
}
