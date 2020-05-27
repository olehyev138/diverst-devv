export default (object, ...args) => {
  const valid = args.find(condition => equals(condition[0], object) || condition[0] == null);
  if (valid)
    return evaluate(valid[1], object);
  return null;
};

const evaluate = (predicate, object = null) => {
  if (typeof predicate === 'function')
    return predicate(object);
  return predicate;
};

const equals = (predicate, object) => {
  if (predicate instanceof Array)
    return predicate.some(sub => equals(sub, object));
  if (typeof predicate === 'function')
    return predicate(object);
  return predicate === object;
};
