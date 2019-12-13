
import dig from 'object-dig';
import { RouteContext } from 'containers/Layouts/ApplicationLayout';

import { ROUTES } from 'containers/Shared/Routes/constants';

import { intl } from 'containers/Shared/LanguageProvider/GlobalLanguageProvider';

/*
 * Provide an interface to the global routing data stored in RouteContext
 *
 *
 * routeContext looks like:
 *   {
 *     computedMatch: { params: { ... }}
 *     location: { ... }
 *   }
 *
 */
export default class RouteService {
  constructor(routeData) {
    if (typeof routeData === 'function') {
      this.contextFunc = routeData;
      this.routeData = this.contextFunc(RouteContext);
      this.match = this.routeData.computedMatch;
      this.location = this.routeData.location;
      this.history = this.routeData.history;
    } else {
      this.match = routeData.computedMatch;
      this.location = routeData.location;
    }
  }

  path() {
    return this.location.pathname;
  }

  // Returns an array no matter what, but passing an array with a string ID as an ID to the server works
  // Ex:   const eventId = rs.params('event_id');
  //       props.getEventBegin({ id: eventId });
  params(...keys) {
    const params = [];
    for (const key of keys)
      params.push(dig(this.match, 'params', key));

    if (params.length === 1)
      return params[0];

    if (params.length === 0)
      return null;

    return params;
  }

  queries(...keys) {
    // todo: - return url query strings in location
    //       - parse with querystring library
  }

  // Returns [title, isPathPrefix]
  // title is null when not found
  // isPathPrefix is true when the title that was found only has a pathPrefix and not a path
  findTitleForPath({ path, object = ROUTES, params = [], textArguments = {} }) {
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
