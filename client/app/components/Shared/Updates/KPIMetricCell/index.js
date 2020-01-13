import React, { memo } from 'react';

import { compose } from 'redux';
import PropTypes from 'prop-types';

import { withStyles } from '@material-ui/core/styles';
import { Card, CardContent, CardHeader, Typography } from '@material-ui/core';
import { DateTime } from 'luxon';

const styles = theme => ({
  negative: {
    color: theme.palette.error.main,
  },
});

export function KPI(props) {
  const { classes, type } = props;

  let toReturn = (<React.Fragment />);
  if (type === 'field')
    toReturn = (
      <Card>
        <CardContent>
          <Typography color='primary' variant='h5' component='h2' className={classes.title}>
            {props.field}
          </Typography>
        </CardContent>
      </Card>
    );
  else if (type === 'update')
    toReturn = (
      <Card>
        <CardHeader
          // title={props.update.comments}
          title={DateTime.fromISO(props.update.report_date).toLocaleString(DateTime.DATE_FULL)}
        />
      </Card>
    );
  else if (type === 'data')
    toReturn = (
      <Card>
        <CardContent>
          <Typography color='primary' variant='h5' component='h2'>
            {props.data.value}
          </Typography>
          { props.data.variance_with_prev && (
            <Typography color='primary' variant='h5' component='h2' className={props.data.variance_with_prev[0] === '-' ? classes.negative : undefined}>
              {props.data.variance_with_prev}
            </Typography>
          )}
        </CardContent>
      </Card>
    );

  return toReturn;
}

KPI.propTypes = {
  classes: PropTypes.object,
  type: PropTypes.oneOf(['field', 'update', 'data']),
  field: PropTypes.string,
  update: PropTypes.shape({
    comments: PropTypes.string.isRequired,
    report_date: PropTypes.string.isRequired,
  }),
  data: PropTypes.shape({
    value: PropTypes.number,
    variance_with_prev: PropTypes.string,
  })
};

export default compose(
  memo,
  withStyles(styles),
)(KPI);
