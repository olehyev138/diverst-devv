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
    marginBottom: -1,
  },
  scrollContentDisplayFlex: {
    display: 'flex',
    flexDirection: 'column',
    height: '100%',
  },
});

export function Scrollbar(props) {
  const { classes, useFlexContainer, ...rest } = props;

  let scrollContentClasses = classes.scrollContent;
  if (useFlexContainer)
    scrollContentClasses = classNames(scrollContentClasses, classes.scrollContentDisplayFlex);

  return (
    <PerfectScrollbar
      options={{
        suppressScrollX: true,
      }}
      className={classNames(scrollContentClasses, CONTENT_SCROLL_CLASS_NAME)}
    >
      {props.children}
    </PerfectScrollbar>
  );
}

Scrollbar.propTypes = {
  classes: PropTypes.object,
  children: PropTypes.any,
  useFlexContainer: PropTypes.bool,
};

export { CONTENT_SCROLL_CLASS_NAME };

export default compose(
  withStyles(styles)
)(Scrollbar);
