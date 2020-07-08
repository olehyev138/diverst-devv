import React, { memo } from 'react';
import { compose } from 'redux';

import { customTexts } from 'utils/customTextHelpers';

import { FormattedMessage } from 'react-intl';
import { createStructuredSelector } from 'reselect';
import { selectCustomText } from 'containers/Shared/App/selectors';
import { connect } from 'react-redux';
import PropTypes from 'prop-types';
import BasicErrorBoundary from 'containers/Shared/BasicErrorBoundary';

export const DiverstFormattedMessage = ({ customText, ...props }) => (
  <BasicErrorBoundary
    render={({ error, info }) => 'UNDEFINED MESSAGE'}
  >
    <FormattedMessage {...props} values={customTexts(customText)} />
  </BasicErrorBoundary>
);

DiverstFormattedMessage.propTypes = {
  customText: PropTypes.object,
};

const mapStateToProps = createStructuredSelector({
  customText: selectCustomText(),
});

const withConnect = connect(
  mapStateToProps,
);

export default compose(memo, withConnect)(DiverstFormattedMessage);
