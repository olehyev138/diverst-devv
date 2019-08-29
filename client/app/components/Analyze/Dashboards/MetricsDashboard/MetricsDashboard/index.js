import React, { memo } from 'react';

import { compose } from 'redux/';
import PropTypes from 'prop-types';
import dig from 'object-dig';

import {
  Paper, Typography, Grid, Button
} from '@material-ui/core/index';
import { withStyles } from '@material-ui/core/styles';

import classNames from 'classnames';

import WrappedNavLink from 'components/Shared/WrappedNavLink';
import messages from 'containers/MetricsDashboard/messages';
import { FormattedMessage } from 'react-intl';

const styles = theme => ({
  padding: {
    padding: theme.spacing(3, 2),
  },
  title: {
    textAlign: 'center',
    fontWeight: 'bold',
    paddingBottom: theme.spacing(3),
  },
  dataHeaders: {
    paddingBottom: theme.spacing(1),
  },
  data: {
    '&:not(:last-of-type)': { // PrmetricsDashboard last data item from adding bottom padding
      paddingBottom: theme.spacing(3),
    },
  },
  buttons: {
    marginLeft: 20,
    float: 'right',
  },
  deleteButton: {
    backgroundColor: theme.palette.error.main,
  },
});

export function MetricsDashboard(props) {
  /* Render an MetricsDashboard */

  const { classes } = props;
  const metricsDashboard = dig(props, 'metricsDashboard');

  return (
    (metricsDashboard) ? (
      <React.Fragment>
        <Grid container spacing={1}>
          <Grid item>
            <Typography color='primary' variant='h5' component='h2' className={classes.title}>
              {metricsDashboard.name}
            </Typography>
          </Grid>
          <Grid item sm>
            <Button
              component={WrappedNavLink}
              to={props.links.metricsDashboardEdit}
              variant='contained'
              size='large'
              color='primary'
              className={classes.buttons}
            >
              <FormattedMessage {...messages.edit} />
            </Button>
            <Button
              variant='contained'
              size='large'
              color='primary'
              className={classNames(classes.buttons, classes.deleteButton)}
              onClick={() => {
                /* eslint-disable-next-line no-alert, no-restricted-globals */
                if (confirm('Delete metricsDashboard?'))
                  props.deleteMetricsDashboardBegin({ id: metricsDashboard.id, group_id: metricsDashboard.owner_group_id });
              }}
            >
              <FormattedMessage {...messages.delete} />
            </Button>
          </Grid>
        </Grid>
        <Paper className={classes.padding}>
          <Typography className={classes.dataHeaders}>
            <FormattedMessage {...messages.show.dateAndTime} />
          </Typography>
          <Typography variant='overline'>From</Typography>
          <Typography color='textSecondary'>{metricsDashboard.start}</Typography>
          <Typography variant='overline'>To</Typography>
          <Typography color='textSecondary' className={classes.data}>{metricsDashboard.end}</Typography>

          <Typography className={classes.dataHeaders}>
            <FormattedMessage {...messages.form.description} />
          </Typography>
          <Typography color='textSecondary' className={classes.data}>
            {metricsDashboard.description}
          </Typography>
        </Paper>
      </React.Fragment>
    ) : <React.Fragment />
  );
}

MetricsDashboard.propTypes = {
  deleteMetricsDashboardBegin: PropTypes.func,
  classes: PropTypes.object,
  metricsDashboard: PropTypes.object,
  currentUserId: PropTypes.number,
  links: PropTypes.shape({
    metricsDashboardEdit: PropTypes.string,
  })
};

export default compose(
  memo,
  withStyles(styles)
)(MetricsDashboard);
