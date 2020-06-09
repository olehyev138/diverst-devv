/*
Used to functionally have an if/else chain but as an expression as oppose to purely a control flow statement
Example use:
instead of
```
let a;
if (b === 5)
  a = 6;
else if (examplePredicate(b))
  a = randomFunction(b);
else if (examplePredicate2(b) || b === 0)
  a = 8;
else
  a = 9;
```
you could write
```
const a = caseHelper(b,
  [5, 6],
  [examplePredicate, randomFunction],
  [[examplePredicate2, 0], 8],
  [null, 9]
);
```

Reason to do this manually is
1: It's trivial
2: Couldn't find a Library as any attempted searches just result in talking about JS switch statements
*/

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
