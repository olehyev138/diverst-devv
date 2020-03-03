import React from 'react';
import { compose } from 'redux';
import PropTypes from 'prop-types';

import { withStyles } from '@material-ui/core/styles';

import classNames from 'classnames';

// Perfect Scrollbar
import 'react-perfect-scrollbar/dist/css/styles.css';
import PerfectScrollbar from 'react-perfect-scrollbar';

const CONTENT_SCROLL_CLASS_NAME = 'primary-content-scroll-container';

const styles = theme => ({
  scrollContent: {
    flexGrow: 1,
    marginTop: 0,
    marginBottom: 6,
  },
});

export function Scrollbar(props) {
  const { classes, ...rest } = props;

  return (
    <PerfectScrollbar
      options={{
        suppressScrollX: true,
      }}
      className={classNames(classes.scrollContent, CONTENT_SCROLL_CLASS_NAME)}
    >
      {props.children}
    </PerfectScrollbar>
  );
}

Scrollbar.propTypes = {
  classes: PropTypes.object,
  children: PropTypes.any,
};

export { CONTENT_SCROLL_CLASS_NAME };

export default compose(
  withStyles(styles)
)(Scrollbar);
