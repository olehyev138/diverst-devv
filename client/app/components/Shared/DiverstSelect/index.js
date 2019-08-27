import React from 'react';
import { compose } from 'redux';
import { withTheme } from '@material-ui/core/styles';
import PropTypes from 'prop-types';
import Select from 'react-select';

export function DiverstSelect(props) {
  const { theme, ...rest } = props;

  return (
    <Select
      // Done to prevent the select menu from being hidden behind other elements
      menuPortalTarget={document.body}
      theme={selectTheme => ({
        ...selectTheme,
        colors: {
          ...selectTheme.colors,
          primary: theme.palette.primary.main,
          primary25: theme.palette.primary.main25,
          primary50: theme.palette.primary.main50,
          primary75: theme.palette.primary.main75,
          danger: theme.palette.error.main,
        }
      })}
      {...rest}
    />
  );
}

DiverstSelect.propTypes = {
  theme: PropTypes.object,
  className: PropTypes.string,
  enterprise: PropTypes.object,
  coloredDefault: PropTypes.bool,
  imgClass: PropTypes.string,
  alt: PropTypes.string,
};

export default compose(
  withTheme,
)(DiverstSelect);
