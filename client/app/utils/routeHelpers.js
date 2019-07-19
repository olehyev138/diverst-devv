
import dig from 'object-dig';
import { RouteContext } from 'containers/Layouts/ApplicationLayout';

/*
 * Pulls out computedMatch object from props and gets the path param specified
 *  - ReactRouter fills every props object with computedMatchObject
 */
export function pathId(props, param) {
  return dig(props, 'computedMatch', 'params', param);
}

export function routeContext(contextFunc, ...keys) {
  /* routeContext looks like:
   *   {
   *     computedMatch: { params: { }}
   *     location: { ... }
   *   }
   *
   */

  const routeParams = contextFunc(RouteContext);

  const ids = [];
  for (const key of keys)
    ids.push(dig(routeParams, 'computedMatch', 'params', key));

  return ids;
}

/*
 * Fills a template path with given params
 * ex:
 *   path: 'group/:group_id
 *   params: { group_id: 5 }
 *     -> /group/5
 */
export function fillPath(path, params) {
  let filledPath = path;

  for (const paramKey of Object.keys(params)) {
    if (!params[paramKey]) continue; // eslint-disable-line no-continue
    filledPath = filledPath.replace(`:${paramKey}`, params[paramKey]);
  }

  return filledPath;
}

/*
 *   path: 'group/:group_id
 *   params: [ 'group_id', 'item_id' ... ]
 *
 */
export function buildPath(path, props, paramKeys) {
  const params = {};
  for (const paramKey of paramKeys)
    params[paramKey] = pathId(props, paramKey);


  return fillPath(path, params);
}
