import React, { useState } from 'react';
import { useCancellablePromises, cancellablePromise, delay } from 'utils/customHooks/cancelablePromises';

const useDelayedTextInputCallback = (inputChange, wait = 300) => {
  const api = useCancellablePromises();
  const [inProgress, setInProgess] = useState(false);

  const handleInputChange = (...args) => {
    setInProgess(true);
    api.clearPendingPromises();
    const waitForAnotherInput = cancellablePromise(delay(wait));
    api.appendPendingPromise(waitForAnotherInput);

    waitForAnotherInput.promise.then(() => {
      api.removePendingPromise(waitForAnotherInput);
      inputChange(...args);
      setInProgess(false);
    }).catch((errorInfo) => {
      api.removePendingPromise(waitForAnotherInput);
      if (!errorInfo.isCanceled)
        throw errorInfo.error;
    });

    return args[0];
  };

  const pendingChanges = () => {
    return inProgress
  }

  return [handleInputChange, pendingChanges];
};

export default useDelayedTextInputCallback;
