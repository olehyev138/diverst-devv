import React, { memo } from 'react';
import { compose } from 'redux';

import { customTexts } from 'utils/customTextHelpers';

import { FormattedMessage } from 'react-intl';

export const DiverstFormattedMessage = props => <FormattedMessage {...props} values={customTexts()} />;

export default compose(memo)(DiverstFormattedMessage);
