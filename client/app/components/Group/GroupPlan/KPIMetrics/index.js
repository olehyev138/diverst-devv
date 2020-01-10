import React, { memo } from 'react';

import { compose } from 'redux';
import PropTypes from 'prop-types';

import { withStyles } from '@material-ui/core/styles';

const styles = theme => ({});

export function Kpi(props) {
  const { classes } = props;

  return (
    <React.Fragment />
  );
}

Kpi.propTypes = {
  classes: PropTypes.object,
};

export default compose(
  memo,
  withStyles(styles),
)(Kpi);
