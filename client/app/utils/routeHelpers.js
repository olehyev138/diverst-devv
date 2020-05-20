import dig from 'object-dig';

import { ROUTES } from 'containers/Shared/Routes/constants';

import { intl } from 'containers/Shared/LanguageProvider/GlobalLanguageProvider';

// Returns [title, isPathPrefix]
// title is null when not found
// isPathPrefix is true when the title that was found only has a pathPrefix and not a path
export const findTitleForPath = ({ path, object = ROUTES, params = [], textArguments = {} }) => {
  if (!object || typeof object !== 'object')
    return [null, null];

    if (Object.hasOwnProperty.call(object, 'data')) {
      if (Object.hasOwnProperty.call(object, 'path')) {
        if (typeof object.path === 'function') {
          if (object.path(...params) === path)
            return [intl.formatMessage(object.data.titleMessage, textArguments), false];
        } else if (object.path === path)
          return [intl.formatMessage(object.data.titleMessage, textArguments), false];
      } else if (Object.hasOwnProperty.call(object.data, 'pathPrefix'))
        if (typeof object.data.pathPrefix === 'function') {
          if (object.data.pathPrefix(...params) === path)
            return [intl.formatMessage(object.data.titleMessage, textArguments), true];
        } else if (object.data.pathPrefix === path)
          return [intl.formatMessage(object.data.titleMessage, textArguments), true];
    } else {
      const subObjects = Object.values(object);
      for (const subObject of subObjects) {
        const [result, isPathPrefix] = this.findTitleForPath({ path, object: subObject, params, textArguments });
        if (result)
          return [result, isPathPrefix];
      }
    }

    return [null, null];
  }
}
