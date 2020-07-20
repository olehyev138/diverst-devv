import React, { memo } from 'react';
import { compose } from 'redux';
import PropTypes from 'prop-types';
import { useParams } from 'react-router-dom';

import WrappedNavLink from 'components/Shared/WrappedNavLink';

import { Tab, Paper, Typography, Button, Box, Grid } from '@material-ui/core';

import { ROUTES } from 'containers/Shared/Routes/constants';

import ResponsiveTabs from 'components/Shared/ResponsiveTabs';

import DiverstFormattedMessage from 'components/Shared/DiverstFormattedMessage';
import messages from 'containers/Event/EventManage/messages';
import BackIcon from '@material-ui/icons/KeyboardBackspaceOutlined';

/* eslint-disable react/no-multi-comp */
export function EventManageLinks(props) {
  const { currentTab, event } = props;
  const { group_id: groupId } = useParams();

  return (
    <React.Fragment>
      <Grid container>
        <Button
          variant='contained'
          to={ROUTES.group.plan.events.index.path(event.owner_group_id)}
          color='secondary'
          size='medium'
          component={WrappedNavLink}
          startIcon={<BackIcon />}
        >
          <DiverstFormattedMessage {...messages.return} />
        </Button>
      </Grid>
      <Box mb={3} />
      <Typography variant='h4' component='h6' align='center' color='primary'>
        <strong>{event.name}</strong>
      </Typography>
      <Box mb={1} />
      <Paper>
        <ResponsiveTabs
          value={currentTab}
          indicatorColor='primary'
          textColor='primary'
        >
          {/* NOT IMPLEMENTED YET */}
          <Tab
            component={WrappedNavLink}
            to={ROUTES.group.plan.events.manage.fields.path(groupId, event.id)}
            label={<DiverstFormattedMessage {...messages.links.fields} />}
            value='fields'
          />
          <Tab
            component={WrappedNavLink}
            to={ROUTES.group.plan.events.manage.updates.index.path(groupId, event.id)}
            label={<DiverstFormattedMessage {...messages.links.updates} />}
            value='updates'
          />
          <Tab
            component={WrappedNavLink}
            to={ROUTES.group.plan.events.manage.expenses.index.path(groupId, event.id)}
            label={<DiverstFormattedMessage {...messages.links.expenses} />}
            value='expenses'
          />
        </ResponsiveTabs>
      </Paper>
    </React.Fragment>
  );
}

EventManageLinks.propTypes = {
  classes: PropTypes.object,
  currentTab: PropTypes.oneOfType([
    PropTypes.string,
    PropTypes.bool,
  ]),
  event: PropTypes.object,
};

export default compose(
  memo,
)(EventManageLinks);
