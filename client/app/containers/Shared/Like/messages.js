import { defineMessages } from 'react-intl';
import { scope } from '../../Event/EventManage/Expense/messages';

export const snackbar = 'diverst.snackbars.Shared.Like';


export default defineMessages({
  snackbars: {
    errors: {
      like: {
        id: `${snackbar}.errors.like`
      },
      unlike: {
        id: `${snackbar}.errors.unlike`
      },
    },
  }
});
