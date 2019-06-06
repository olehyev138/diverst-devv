import { SHOW_SNACKBAR, CLOSE_SNACKBAR, REMOVE_SNACKBAR } from './constants';
import produce from "immer";

export const initialState = {
  notifications: [],
};

function notifierReducer(state = initialState, action) {
  return produce(state, draft => {
    switch (action.type) {
      case SHOW_SNACKBAR:
        draft.notifications.push({
          key: action.key,
          ...action.notification,
        });
        break;

      case CLOSE_SNACKBAR:
        draft.notifications.map(notification => (
          (action.dismissAll || notification.key === action.key)
            ? {...notification, dismissed: true}
            : {...notification}
        ));
        break;

      case REMOVE_SNACKBAR:
        draft.notifications.filter(
          notification => notification.key !== action.key,
        );
        break;
    }
  });
}

export default notifierReducer;
