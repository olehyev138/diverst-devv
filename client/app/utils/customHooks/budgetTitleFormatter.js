import React, { useCallback, useRef } from 'react';
import messages from 'containers/Shared/App/messages';

export const useBudgetFormatter = (intl) => {
  const formatQuarter = useCallback(quarter => intl.formatMessage(messages.budgets.quarterAbbreviation, { quarter }), [intl]);
  const formatYear = useCallback(year => intl.formatMessage(messages.budgets.yearAbbreviation, { year }), [intl]);
  const formatYearAndQuarter = useCallback((year, quarter = null) => {
    if (quarter)
      return intl.formatMessage(messages.budgets.yearAndQuarter, { year, quarter });
    return intl.formatMessage(messages.budgets.yearAbbreviation, { year });
  }, [intl]);
  return { formatQuarter, formatYear, formatYearAndQuarter };
};
