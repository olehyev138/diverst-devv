import React from 'react';
import { compose } from 'redux';
import PropTypes from 'prop-types';

import { withStyles } from '@material-ui/core/styles';

// Scrollbar
import 'react-perfect-scrollbar/dist/css/styles.css';
import PerfectScrollbar from 'react-perfect-scrollbar';

const styles = theme => ({
  scrollContent: {
    flexGrow: 1,
    marginTop: 3,
    marginBottom: 3,
  }
});

export function Scrollbar(props) {
  const { classes, ...rest } = props;

  return (
    <PerfectScrollbar className={classes.scrollContent}>
      {props.children}
    </PerfectScrollbar>
  );
}

Scrollbar.propTypes = {
  classes: PropTypes.object,
  children: PropTypes.any,
};

export default compose(
  withStyles(styles())
)(Scrollbar);
