import React, { useRef } from 'react';
import { useCancellablePromises, cancellablePromise, delay } from 'utils/cancelablePromises/cancelablePromises';

const delayedTextInputCallback = (inputChange, wait = 100) => {
  const api = useCancellablePromises();

  const handleInputChange = (...args) => {
    api.clearPendingPromises();
    const waitForAnotherInput = cancellablePromise(delay(wait));
    api.appendPendingPromise(waitForAnotherInput);

    return waitForAnotherInput.promise.then(() => {
      api.removePendingPromise(waitForAnotherInput);
      inputChange(...args);
    }).catch((errorInfo) => {
      api.removePendingPromise(waitForAnotherInput);
      if (!errorInfo.isCanceled)
        throw errorInfo.error;
    });
  };

  return delayedTextInputCallback;
};

export default delayedTextInputCallback;
