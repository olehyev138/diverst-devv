/*
 *
 * LanguageToggle
 *
 */

import React from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { createSelector } from 'reselect';

import { appLocales } from 'i18n';
import { changeLocale } from 'containers/Shared/LanguageProvider/actions';
import { selectLocale } from 'containers/Shared/LanguageProvider/selectors';

import DiverstLanguageSelect from 'components/Shared/DiverstLanguageSelect';

export class LocaleToggle extends React.PureComponent {
  // eslint-disable-line react/prefer-stateless-function
  render() {
    return (
      <DiverstLanguageSelect
        value={this.props.locale}
        values={appLocales}
        onToggle={this.props.onLocaleToggle}
      />
    );
  }
}

LocaleToggle.propTypes = {
  onLocaleToggle: PropTypes.func,
  locale: PropTypes.string,
};

const mapStateToProps = createSelector(selectLocale(), locale => ({
  locale,
}));

export function mapDispatchToProps(dispatch) {
  return {
    onLocaleToggle: evt => dispatch(changeLocale(evt.target.value)),
    dispatch,
  };
}

export default connect(
  mapStateToProps,
  mapDispatchToProps,
)(LocaleToggle);
