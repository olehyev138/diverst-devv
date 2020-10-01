import React, { memo, useState } from 'react';

import { compose } from 'redux/';
import PropTypes from 'prop-types';
import ResponsiveTabs from 'components/Shared/ResponsiveTabs';

import {
  Paper, Typography, Grid, Button, Box, Card, CardContent, Link, Hidden, Divider, CardActions, CardActionArea,
  Tab } from '@material-ui/core/index';
import { withStyles } from '@material-ui/core/styles';
import messages from 'containers/Archive/messages';
import RestoreIcon from '@material-ui/icons/Restore';
import EventsTable from 'components/Archive/EventsTable';
import ResourcesTable from '../ResourcesTable';
import PostsTable from '../PostsTable';
import DiverstFormattedMessage from '../../Shared/DiverstFormattedMessage';

const styles = theme => ({
  link: {
    textDecoration: 'none !important',
  },
  arrowRight: {
    color: theme.custom.colors.grey,
    marginRight: 8,
  },
  deleteButton: {
    color: theme.palette.error.main,
  },
});

const ArchiveTypes = Object.freeze({
  posts: 0,
  resources: 1,
  events: 2,
});

export function ArchiveList(props) {
  return (
    <React.Fragment>
      <Paper>
        <ResponsiveTabs
          value={props.currentTab}
          onChange={props.handleChangeTab}
          indicatorColor='primary'
          textColor='primary'
        >
          <Tab label={<DiverstFormattedMessage {...messages.posts} />} />
          <Tab label={<DiverstFormattedMessage {...messages.resources} />} />
          <Tab label={<DiverstFormattedMessage {...messages.events} />} />
        </ResponsiveTabs>
      </Paper>
      <br />
      {props.archives != null && (
        <Grid container spacing={3}>
          <Grid item xs>
            {props.currentTab === ArchiveTypes.events && (
              <EventsTable
                title={messages.tableName}
                archives={props.archives}
                archivesTotal={props.archivesTotal}
                isLoading={props.isLoading}
                handlePagination={props.handlePagination}
                handleOrdering={props.handleOrdering}
                handleRestore={props.handleRestore}
                rowsPerPage={10}
                customTexts={props.customTexts}
              />
            )}

            {props.currentTab === ArchiveTypes.resources && (
              <ResourcesTable
                title={messages.tableName}
                archives={props.archives}
                archivesTotal={props.archivesTotal}
                isLoading={props.isLoading}
                handlePagination={props.handlePagination}
                handleOrdering={props.handleOrdering}
                handleRestore={props.handleRestore}
                customTexts={props.customTexts}
                rowsPerPage={10}
              />
            )}

            {props.currentTab === ArchiveTypes.posts && (
              <PostsTable
                title={messages.tableName}
                archives={props.archives}
                archivesTotal={props.archivesTotal}
                isLoading={props.isLoading}
                handlePagination={props.handlePagination}
                handleOrdering={props.handleOrdering}
                handleRestore={props.handleRestore}
                customTexts={props.customTexts}
                rowsPerPage={10}
              />
            )}
          </Grid>
        </Grid>
      )}
    </React.Fragment>
  );
}

ArchiveList.propTypes = {
  archives: PropTypes.array,
  archivesTotal: PropTypes.number,
  classes: PropTypes.object,
  currentTab: PropTypes.number,
  handleChangeTab: PropTypes.func,
  handlePagination: PropTypes.func,
  handleOrdering: PropTypes.func,
  handleRestore: PropTypes.func,
  columns: PropTypes.array,
  isLoading: PropTypes.bool,
  customTexts: PropTypes.object,
};

export default compose(
  memo,
  withStyles(styles)
)(ArchiveList);
