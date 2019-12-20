import React, { memo } from 'react';
import { compose } from 'redux';
import PropTypes from 'prop-types';

import WrappedNavLink from 'components/Shared/WrappedNavLink';

import { Tab, Paper } from '@material-ui/core';
import { withStyles } from '@material-ui/core/styles';

import { ROUTES } from 'containers/Shared/Routes/constants';

import ResponsiveTabs from 'components/Shared/ResponsiveTabs';
import DiverstFormattedMessage from 'components/Shared/DiverstFormattedMessage';
import messages from 'containers/Group/GroupPlan/KPI/messages';

const styles = theme => ({});

/* eslint-disable react/no-multi-comp */
export function KPILinks(props) {
  const { currentTab } = props;

  return (
    <React.Fragment>
      <Paper>
        <ResponsiveTabs
          value={currentTab}
          indicatorColor='primary'
          textColor='primary'
        >
          <Tab
            component={WrappedNavLink}
            to={ROUTES.group.plan.kpi.metrics.path(props.currentGroup.id)}
            label={<DiverstFormattedMessage {...messages.links.metrics} />}
          />
          <Tab
            component={WrappedNavLink}
            to={ROUTES.group.plan.kpi.fields.path(props.currentGroup.id)}
            label={<DiverstFormattedMessage {...messages.links.fields} />}
          />
          <Tab
            component={WrappedNavLink}
            to={ROUTES.group.plan.kpi.updates.path(props.currentGroup.id)}
            label={<DiverstFormattedMessage {...messages.links.updates} />}
          />
        </ResponsiveTabs>
      </Paper>
    </React.Fragment>
  );
}

KPILinks.propTypes = {
  classes: PropTypes.object,
  currentTab: PropTypes.number,
  currentGroup: PropTypes.object,
};

export const StyledGroupManageLinks = withStyles(styles)(KPILinks);

export default compose(
  withStyles(styles),
  memo,
)(KPILinks);
