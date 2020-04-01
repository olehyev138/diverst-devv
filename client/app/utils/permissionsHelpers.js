import dig from 'object-dig';

export const permission = (object, permission) => dig(object, 'permissions', permission);
