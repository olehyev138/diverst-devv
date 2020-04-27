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

import LocaleService from 'utils/localeService';

export class LocaleToggle extends React.PureComponent {
  handleLocaleToggle = (e) => {
    const { value } = e.target;

    this.props.onLocaleToggle(value);
    LocaleService.storeLocale(value);
  }

  // eslint-disable-line react/prefer-stateless-function
  render() {
    return (
      <DiverstLanguageSelect
        value={this.props.locale}
        values={appLocales}
        onToggle={this.handleLocaleToggle}
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
    onLocaleToggle: value => dispatch(changeLocale(value)),
    dispatch,
  };
}

export default connect(
  mapStateToProps,
  mapDispatchToProps,
)(LocaleToggle);
