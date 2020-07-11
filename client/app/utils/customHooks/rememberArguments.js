import React, { useRef } from 'react';
import { useCancellablePromises, cancellablePromise, delay } from 'utils/customHooks/cancelablePromises';

function useArgumentRemembering(
  method,
  numberOfHeldParams = 1
) {
  const rememberedArguments = useRef([]);

  function cachedFunction(...args) {
    const stringedArgs = JSON.stringify(args);
    const cachedResult = rememberedArguments.current.find(el => el[0] === stringedArgs);
    if (cachedResult)
      return cachedResult[1];

    const result = method(...args);
    rememberedArguments.current = [[stringedArgs, result], ...rememberedArguments.current.slice(0, numberOfHeldParams - 1)];
    return result;
  }

  return cachedFunction;
}

export default useArgumentRemembering;
