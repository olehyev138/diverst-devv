/**
 *
 * PollList List
 *
 */

import React, { memo, useState } from 'react';
import PropTypes from 'prop-types';
import { compose } from 'redux';

import WrappedNavLink from 'components/Shared/WrappedNavLink';

import {
  Button, Card, CardContent, CardActions,
  Typography, Grid, Link, Collapse, Box,
} from '@material-ui/core';
import { withStyles } from '@material-ui/core/styles';

import AddIcon from '@material-ui/icons/Add';
import EditIcon from '@material-ui/icons/Edit';
import DeleteIcon from '@material-ui/icons/DeleteOutline';
import DiverstTable from 'components/Shared/DiverstTable';

import DiverstFormattedMessage from 'components/Shared/DiverstFormattedMessage';
import messages from 'containers/Poll/messages';
import { injectIntl, intlShape } from 'react-intl';
import { DateTime, formatDateTimeString } from 'utils/dateTimeHelpers';

const styles = theme => ({
  pollListItem: {
    width: '100%',
  },
  pollListItemDescription: {
    paddingTop: 8,
  },
  errorButton: {
    color: theme.palette.error.main,
  },
});

export function PollList(props, context) {
  const { classes } = props;
  const { links, intl } = props;
  const [expandedPolls, setExpandedPolls] = useState({});

  /* Store a expandedPollsHash for each poll, that tracks whether or not its children are expanded */
  if (props.polls && Object.keys(props.polls).length !== 0 && Object.keys(expandedPolls).length <= 0) {
    const initialExpandedPolls = {};

    /* Setup initial hash, with each poll set to false - do it like this because of how React works with state */
    /* eslint-disable-next-line no-return-assign */
    Object.keys(props.polls).map((id, i) => initialExpandedPolls[id] = false); // eslint-disable
    setExpandedPolls(initialExpandedPolls);
  }

  const columns = [
    {
      title: <DiverstFormattedMessage {...messages.list.name} />,
      field: 'title',
      query_field: 'title'
    },
    {
      title: <DiverstFormattedMessage {...messages.list.questions} />,
      field: 'fields_count',
      sorting: false,
    },
    {
      title: <DiverstFormattedMessage {...messages.list.responses} />,
      field: 'responses_count',
      sorting: false,
    },
    {
      title: <DiverstFormattedMessage {...messages.list.creationDate} />,
      field: 'created_at',
      query_field: 'created_at',
      render: rowData => formatDateTimeString(rowData.created_at, DateTime.DATE_SHORT)
    },
    {
      title: <DiverstFormattedMessage {...messages.list.status} />,
      field: 'status',
      query_field: 'status'
    },
  ];

  const handleOrderChange = (columnId, orderDir) => {
    props.handleOrdering({
      orderBy: (columnId === -1) ? 'id' : `${columns[columnId].query_field}`,
      orderDir: (columnId === -1) ? 'asc' : orderDir
    });
  };

  const actions = [];

  actions.push(rowData => ({
    icon: () => <EditIcon />,
    tooltip: intl.formatMessage(messages.list.edit),
    onClick: (_, rowData) => {
      props.handlePollEdit(rowData.id);
    },
    disabled: true // !permission(rowData, 'update?')
  }));

  actions.push(rowData => ({
    icon: () => <DeleteIcon />,
    tooltip: intl.formatMessage(messages.list.delete),
    onClick: (_, rowData) => {
      /* eslint-disable-next-line no-alert, no-restricted-globals */
      if (confirm(intl.formatMessage(messages.delete_confirm)))
        props.deletePollBegin(rowData.id);
    },
    disabled: true // !permission(rowData, 'destroy?')
  }));

  return (
    <React.Fragment>
      <Grid container spacing={3} justify='flex-end'>
        <Grid item>
          <Button
            variant='contained'
            to={links.pollNew}
            color='primary'
            size='large'
            component={WrappedNavLink}
            startIcon={<AddIcon />}
          >
            <DiverstFormattedMessage {...messages.new} />
          </Button>
        </Grid>
      </Grid>
      <Box mb={1} />
      <Grid container spacing={3}>
        <Grid item xs>
          <DiverstTable
            title={intl.formatMessage(messages.list.title)}
            handlePagination={props.handlePagination}
            onOrderChange={handleOrderChange}
            isLoading={props.isLoading}
            rowsPerPage={5}
            dataArray={props.polls}
            dataTotal={props.pollTotal}
            columns={columns}
            actions={actions}
          />
        </Grid>
      </Grid>

    </React.Fragment>
  );
}
PollList.propTypes = {
  intl: intlShape,
  classes: PropTypes.object,
  polls: PropTypes.array,
  pollTotal: PropTypes.number,
  isLoading: PropTypes.bool,
  deletePollBegin: PropTypes.func,
  handlePagination: PropTypes.func,
  handleOrdering: PropTypes.func,
  handlePollEdit: PropTypes.func,
  handleChangeScope: PropTypes.func,
  links: PropTypes.shape({
    pollNew: PropTypes.string,
    pollEdit: PropTypes.func
  })
};
export default compose(
  injectIntl,
  memo,
  withStyles(styles),
)(PollList);
