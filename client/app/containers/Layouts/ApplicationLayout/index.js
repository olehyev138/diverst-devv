import React, { memo } from 'react';
import { Route } from 'react-router-dom';
import PropTypes from 'prop-types';
import { compose } from 'redux';

import CssBaseline from '@material-ui/core/CssBaseline';
import Box from '@material-ui/core/Box';
import Fade from '@material-ui/core/Fade';

const ApplicationLayout = (props) => {
  const { classes, children, ...rest } = props;

  return (
    <React.Fragment>
      <CssBaseline />
      <Fade in appear>
        <Box height='100%' minHeight='100%' minWidth='100%' display='flex' flexDirection='column' overflow='hidden'>
          {children}
        </Box>
      </Fade>
    </React.Fragment>
  );
};

ApplicationLayout.propTypes = {
  classes: PropTypes.object,
  children: PropTypes.any,
};

export default compose(
  memo,
)(ApplicationLayout);
