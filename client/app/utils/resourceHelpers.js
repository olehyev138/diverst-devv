import { ROUTES } from 'containers/Shared/Routes/constants';

export function getFolderShowPath(folder) {
  if (folder.group_id)
    return ROUTES.group.resources.folders.show.path(folder.group_id, folder.id);
  if (folder.enterprise_id)
    return ROUTES.admin.manage.resources.folders.show.path(folder.id);

  return null;
}

export function getFolderIndexPath(folder) {
  if (folder.group_id)
    return ROUTES.group.resources.folders.index.path(folder.group_id);
  if (folder.enterprise_id)
    return ROUTES.admin.manage.resources.folders.index.path();

  return null;
}

export function getParentPage(folder) {
  if (folder == null)
    return null;
  if (folder.parent)
    return getFolderShowPath(folder.parent);
  return getFolderIndexPath(folder);
}
