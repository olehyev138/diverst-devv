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
import messages from 'containers/Analyze/Dashboards/MetricsDashboard/messages';
import DiverstFormattedMessage from 'components/Shared/DiverstFormattedMessage';

import CustomGraphPage from 'containers/Analyze/Dashboards/MetricsDashboard/CustomGraph/CustomGraphPage';
import DiverstShowLoader from 'components/Shared/DiverstShowLoader';
import Permission from 'components/Shared/DiverstPermission';
import { permission } from 'utils/permissionsHelpers';

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
    '&:not(:last-of-type)': {
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
  const { classes } = props;
  const metricsDashboard = dig(props, 'metricsDashboard');

  return (
    <DiverstShowLoader isLoading={props.isFormLoading} isError={!props.isFormLoading && !metricsDashboard}>
      {metricsDashboard && (
        <React.Fragment>
          <Grid container spacing={1}>
            <Grid item>
              <Typography color='primary' variant='h5' component='h2' className={classes.title}>
                {metricsDashboard.name}
              </Typography>
            </Grid>
            <Grid item sm>
              <Permission show={permission(metricsDashboard, 'update?')}>
                <Button
                  variant='contained'
                  size='large'
                  color='primary'
                  className={classNames(classes.buttons, classes.deleteButton)}
                  onClick={() => {
                    /* eslint-disable-next-line no-alert, no-restricted-globals */
                    if (confirm('Delete metricsDashboard?'))
                      props.deleteMetricsDashboardBegin(metricsDashboard.id);
                  }}
                >
                  <DiverstFormattedMessage {...messages.delete} />
                </Button>
              </Permission>
              <Permission show={permission(metricsDashboard, 'destroy?')}>
                <Button
                  component={WrappedNavLink}
                  to={props.links.metricsDashboardEdit}
                  variant='contained'
                  size='large'
                  color='primary'
                  className={classes.buttons}
                >
                  <DiverstFormattedMessage {...messages.edit} />
                </Button>
              </Permission>
            </Grid>
            <Permission show={permission(metricsDashboard, 'update?')}>
              <Grid item xs>
                <Button
                  component={WrappedNavLink}
                  variant='contained'
                  size='large'
                  color='primary'
                  className={classNames(classes.buttons)}
                  to={props.links.customGraphNew}
                >
                  <DiverstFormattedMessage {...messages.creategraph} />
                </Button>
              </Grid>
            </Permission>
          </Grid>
          <Grid container spacing={3}>
            {metricsDashboard.graphs && metricsDashboard.graphs.map((graph => (
              <Grid item key={graph.id}>
                <CustomGraphPage customGraph={graph} />
              </Grid>
            )))}
          </Grid>
        </React.Fragment>
      )}
    </DiverstShowLoader>
  );
}

MetricsDashboard.propTypes = {
  deleteMetricsDashboardBegin: PropTypes.func,
  classes: PropTypes.object,
  metricsDashboard: PropTypes.object,
  currentUserId: PropTypes.number,
  isFormLoading: PropTypes.bool,
  links: PropTypes.shape({
    metricsDashboardEdit: PropTypes.string,
    customGraphNew: PropTypes.string,
  })
};

export default compose(
  memo,
  withStyles(styles)
)(MetricsDashboard);
