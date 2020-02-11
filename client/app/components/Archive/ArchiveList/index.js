import React, { memo, useState } from 'react';

import { compose } from 'redux/';
import PropTypes from 'prop-types';
import ResponsiveTabs from 'components/Shared/ResponsiveTabs';
import { intl } from 'containers/Shared/LanguageProvider/GlobalLanguageProvider';
import {
  Paper, Typography, Grid, Button, Box, Card, CardContent, Link, Hidden, Divider, CardActions, CardActionArea,
  Tab } from '@material-ui/core/index';
import { withStyles } from '@material-ui/core/styles';
import messages from 'containers/Archive/messages';
import DiverstTable from 'components/Shared/DiverstTable';
import { injectIntl, intlShape } from 'react-intl';
import { DateTime, formatDateTimeString } from 'utils/dateTimeHelpers';
import RestoreIcon from '@material-ui/icons/Restore';

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

const columns = [
  {
    title: intl.formatMessage(messages.title),
    field: 'title',
    query_field: 'title'
  },
  {
    title: intl.formatMessage(messages.url),
    field: 'url',
    query_field: 'url',
  },
  {
    title: intl.formatMessage(messages.creation),
    field: 'created_at',
    query_field: 'created_at',
    render: rowData => formatDateTimeString(rowData.created_at, DateTime.DATE_SHORT)
  },
];

export function ArchiveList(props) {
  const { classes } = props;
  return (
    <React.Fragment>
      <Paper>
        <ResponsiveTabs
          value={props.currentTab}
          onChange={props.handleChangeTab}
          indicatorColor='primary'
          textColor='primary'
        >
          <Tab label={intl.formatMessage(messages.posts)} />
          <Tab label={intl.formatMessage(messages.resources)} />
          <Tab label={intl.formatMessage(messages.events)} />
        </ResponsiveTabs>
      </Paper>
      <br />
      {props.archives != null && (
        <Grid container spacing={3}>
          <Grid item xs>
            <DiverstTable
              title='Archives'
              handlePagination={props.handlePagination}
              handleOrdering={props.handleOrdering}
              rowsPerPage={10}
              dataArray={Object.values(props.archives)}
              dataTotal={props.archivesTotal}
              columns={columns}
              actions={[{
                icon: () => <RestoreIcon />,
                tooltip: 'Restore',
                onClick: (_, rowData) => {
                  // TODO NEED TO PASS current ResourceType
                  props.handleRestore(rowData.id);
                }
              }]}
            />
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
  intl: intlShape.isRequired,
  currentTab: PropTypes.number,
  handleChangeTab: PropTypes.func,
  handlePagination: PropTypes.func,
  handleOrdering: PropTypes.func,
  handleRestore: PropTypes.func,
};

export default compose(
  memo,
  injectIntl,
  withStyles(styles)
)(ArchiveList);
