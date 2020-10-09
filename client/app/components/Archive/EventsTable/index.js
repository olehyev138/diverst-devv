import React, { memo, useEffect, useContext, useState } from 'react';
import PropTypes from 'prop-types';
import { compose } from 'redux';
import DiverstTable from 'components/Shared/DiverstTable';
import { injectIntl, intlShape } from 'react-intl';

import { DateTime, formatDateTimeString } from 'utils/dateTimeHelpers';
import messages from 'containers/Archive/messages';
import RestoreIcon from '@material-ui/icons/Restore';
import { withStyles } from '@material-ui/core/styles';

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

export function EventsTable(props) {
  const { intl } = props;

  const columns = [
    {
      title: intl.formatMessage(messages.event, props.customTexts),
      field: 'name',
      query_field: 'name'
    },
    {
      title: intl.formatMessage(messages.group, props.customTexts),
      field: 'group.name',
      query_field: 'groups.name'
    },
    {
      title: intl.formatMessage(messages.creation, props.customTexts),
      field: 'created_at',
      query_field: 'created_at',
      render: rowData => formatDateTimeString(rowData.created_at, DateTime.DATE_SHORT)
    },
  ];

  const handleOrderChange = (columnId, orderDir) => {
    props.handleOrdering({
      orderBy: (columnId === -1) ? 'initiatives.id' : `${columns[columnId].query_field}`,
      orderDir: (columnId === -1) ? 'asc' : orderDir
    });
  };

  return (
    <DiverstTable
      title={props.title}
      isLoading={props.isLoading}
      handlePagination={props.handlePagination}
      onOrderChange={handleOrderChange}
      rowsPerPage={10}
      dataArray={Object.values(props.archives)}
      dataTotal={props.archivesTotal}
      columns={columns}
      actions={[{
        icon: () => <RestoreIcon />,
        tooltip: intl.formatMessage(messages.restore, props.customTexts),
        onClick: (_, rowData) => {
          props.handleRestore(rowData.id);
        }
      }]}
    />
  );
}

EventsTable.propTypes = {
  intl: intlShape.isRequired,
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
  title: PropTypes.object
};

export default compose(
  injectIntl,
  memo,
  withStyles(styles)
)(EventsTable);
