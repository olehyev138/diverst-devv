import dig from 'object-dig';

export const permission = (object, permission) => object?.permissions?.[permission];
