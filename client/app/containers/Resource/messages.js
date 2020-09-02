/*
 * Resources
 *
 * This contains all the text for the Resources & Folders containers/components.
 */

import { defineMessages } from 'react-intl';

export const snackbar = 'diverst.snackbars.Resource';

export default defineMessages({
  snackbars: {
    errors: {
      resource: {
        id: `${snackbar}.errors.load.resource`
      },
      resources: {
        id: `${snackbar}.errors.load.resources`
      },
      folder: {
        id: `${snackbar}.errors.load.folder`
      },
      folders: {
        id: `${snackbar}.errors.load.folders`
      },
      create_resource: {
        id: `${snackbar}.errors.create.resource`
      },
      update_resource: {
        id: `${snackbar}.errors.update.resource`
      },
      delete_resource: {
        id: `${snackbar}.errors.delete.resource`
      },
      create_folder: {
        id: `${snackbar}.errors.create.folder`
      },
      update_folder: {
        id: `${snackbar}.errors.update.folder`
      },
      delete_folder: {
        id: `${snackbar}.errors.delete.folder`
      },
      archive: {
        id: `${snackbar}.errors.archive`
      },
      password: {
        id: `${snackbar}.errors.password`
      },
      file_data: {
        id: `${snackbar}.errors.file_data`
      },
    },
    success: {
      create_resource: {
        id: `${snackbar}.success.create.resource`
      },
      update_resource: {
        id: `${snackbar}.success.update.resource`
      },
      delete_resource: {
        id: `${snackbar}.success.delete.resource`
      },
      create_folder: {
        id: `${snackbar}.success.create.folder`
      },
      update_folder: {
        id: `${snackbar}.success.update.folder`
      },
      delete_folder: {
        id: `${snackbar}.success.delete.folder`
      },
      archive: {
        id: `${snackbar}.success.archive`
      },
    }
  }
});
