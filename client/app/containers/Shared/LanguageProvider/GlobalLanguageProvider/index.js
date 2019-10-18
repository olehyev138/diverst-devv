/*
 *
 * GlobalLanguageProvider
 *
 */

import React, { memo } from 'react';
import PropTypes from 'prop-types';
import { compose } from 'redux';
import { injectIntl } from 'react-intl';

/* eslint-disable-next-line import/no-mutable-exports */
export let intl = null;

export function GlobalLanguageProvider(props) {
  /* eslint-disable-next-line prefer-destructuring */
  intl = props.intl;

  return props.children;
}

GlobalLanguageProvider.propTypes = {
  children: PropTypes.element.isRequired,
};

export default compose(
  memo,
  injectIntl,
)(GlobalLanguageProvider);
