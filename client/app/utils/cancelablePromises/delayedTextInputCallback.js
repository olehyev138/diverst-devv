import React, { useRef } from 'react';
import { useCancellablePromises, cancellablePromise, delay } from 'utils/cancelablePromises/cancelablePromises';

const useDelayedTextInputCallback = (inputChange, wait = 300) => {
  const api = useCancellablePromises();

  const handleInputChange = (...args) => {
    api.clearPendingPromises();
    const waitForAnotherInput = cancellablePromise(delay(wait));
    api.appendPendingPromise(waitForAnotherInput);

    waitForAnotherInput.promise.then(() => {
      api.removePendingPromise(waitForAnotherInput);
      inputChange(...args);
    }).catch((errorInfo) => {
      api.removePendingPromise(waitForAnotherInput);
      if (!errorInfo.isCanceled)
        throw errorInfo.error;
    });

    return args[0];
  };

  return handleInputChange;
};

export default useDelayedTextInputCallback;
