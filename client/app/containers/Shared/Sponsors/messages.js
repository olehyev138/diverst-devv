import { defineMessages } from 'react-intl';
import {scope} from "../Field/messages";

export const snackbar = 'diverst.snackbars.Shared.Sponsors';


export default defineMessages({
  snackbars: {
    errors: {
      sponsor: {
        id: `${snackbar}.errors.load.sponsor`
      },
      sponsors: {
        id: `${snackbar}.errors.load.sponsors`
      },
      create: {
        id: `${snackbar}.errors.create.sponsor`
      },
      update: {
        id: `${snackbar}.errors.update.sponsor`
      },
      delete: {
        id: `${snackbar}.errors.delete.sponsor`
      }
    },
    success:{
      create: {
        id: `${snackbar}.success.create.sponsor`
      },
      update: {
        id: `${snackbar}.success.update.sponsor`
      },
      delete: {
        id: `${snackbar}.success.delete.sponsor`
      }
    }
  }
});
