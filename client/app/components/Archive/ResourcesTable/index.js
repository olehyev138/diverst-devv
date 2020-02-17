import React, { memo, useEffect, useContext, useState } from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { createStructuredSelector } from 'reselect/lib';
import { compose } from 'redux';

import { useInjectSaga } from 'utils/injectSaga';
import { useInjectReducer } from 'utils/injectReducer';
import DiverstTable from 'components/Shared/DiverstTable';
import reducer from 'containers/Archive/reducer';
import saga from 'containers/Archive/saga';
import { getArchivesBegin, restoreArchiveBegin } from 'containers/Archive/actions';
import ArchiveList from 'components/Archive/ArchiveList';
import dig from 'object-dig';
import { injectIntl, intlShape } from 'react-intl';
import { intl } from 'containers/Shared/LanguageProvider/GlobalLanguageProvider';
import { DateTime, formatDateTimeString } from 'utils/dateTimeHelpers';
import messages from 'containers/Archive/messages';
import { Grid } from '@material-ui/core';
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

const resourceColumns = [
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

export function ResourcesTable(props) {
  console.log(props);
  return (
    <DiverstTable
      title='Archives'
      isLoading={props.isLoading}
      handlePagination={props.handlePagination}
      handleOrdering={props.handleOrdering}
      rowsPerPage={10}
      dataArray={Object.values(props.archives)}
      dataTotal={props.archivesTotal}
      columns={resourceColumns}
      actions={[{
        icon: () => <RestoreIcon />,
        tooltip: 'Restore',
        onClick: (_, rowData) => {
          props.handleRestore(rowData.id);
        }
      }]}
    />
  );
}

ResourcesTable.propTypes = {
  archives: PropTypes.array,
  archivesTotal: PropTypes.number,
  classes: PropTypes.object,
  intl: intlShape.isRequired,
  currentTab: PropTypes.number,
  handleChangeTab: PropTypes.func,
  handlePagination: PropTypes.func,
  handleOrdering: PropTypes.func,
  handleRestore: PropTypes.func,
  columns: PropTypes.array,
  isLoading: PropTypes.bool
};

export default compose(
  memo,
  injectIntl,
  withStyles(styles)
)(ResourcesTable);
