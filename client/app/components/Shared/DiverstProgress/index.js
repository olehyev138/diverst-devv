import React, { memo } from 'react';
import { compose } from 'redux';
import PropTypes from 'prop-types';
import { withStyles, lighten } from '@material-ui/core/styles';
import { Box, LinearProgress } from '@material-ui/core';
import { percent, clamp } from 'utils/floatRound';

// This component is intended for rendering images from a base64 string,
// likely image data encoded in base64 received from a serializer.
export function DiverstProgress(props) {
  const { classes, ...rest } = props;

  const basicBarStyle = {
    root: {
      height: 7,
      backgroundColor: '#eee',
      borderRadius: 1000,
    },
    bar: {
      borderRadius: 1000,
    }
  };

  const NoErrorProgress = withStyles({
    ...basicBarStyle
  })(LinearProgress);

  const Error2Progress = withStyles(theme => ({
    ...basicBarStyle,
    bar2Buffer: {
      backgroundColor: lighten(theme.palette.error.main, 0.5),
    },
  }))(LinearProgress);

  const Error1Progress = withStyles(theme => ({
    ...basicBarStyle,
    barColorPrimary: {
      backgroundColor: theme.palette.error.main,
    },
    bar1Buffer: {
      backgroundColor: theme.palette.error.main,
    },
  }))(LinearProgress);

  const RoundedBox = withStyles({
    root: {
      borderRadius: 1000,
    },
  })(Box);

  const value = percent(rest.number, rest.total);
  const valueBuffer = percent(rest.buffer || 0, rest.total);

  let BorderLinearProgress;
  if (value > 100)
    BorderLinearProgress = Error1Progress;
  else if (valueBuffer > 100)
    BorderLinearProgress = Error2Progress;
  else
    BorderLinearProgress = NoErrorProgress;


  return (
    <React.Fragment>
      <RoundedBox boxShadow={1}>
        <BorderLinearProgress
          variant={rest.buffer ? 'buffer' : 'determinate'}
          value={clamp(value, 0, 100)}
          valueBuffer={clamp(valueBuffer, 0, 100)}
        />
      </RoundedBox>
    </React.Fragment>
  );
}

DiverstProgress.propTypes = {
  classes: PropTypes.object,
  number: PropTypes.oneOfType([PropTypes.string, PropTypes.number]).isRequired,
  buffer: PropTypes.oneOfType([PropTypes.string, PropTypes.number]),
  total: PropTypes.oneOfType([PropTypes.string, PropTypes.number]).isRequired,
};

export default compose(
  memo,
)(DiverstProgress);
