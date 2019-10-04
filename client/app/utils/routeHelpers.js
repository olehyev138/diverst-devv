
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

    return params;
  }

  queries(...keys) {
    // todo: - return url query strings in location
    //       - parse with querystring library
  }

  findTitleForPath({ path, object = ROUTES, params = [] }) {
    if (!object || typeof object !== 'object')
      return null;

    if (Object.hasOwnProperty.call(object, 'path') && typeof object.path === 'function') {
      if (object.path(...params) === path)
        return intl.formatMessage(object.data.titleMessage);
    } else {
      const subObjects = Object.values(object);
      for (const subObject of subObjects) {
        const result = this.findTitleForPath({ path, object: subObject, params });
        if (result)
          return result;
      }
    }

    return null;
  }
}
