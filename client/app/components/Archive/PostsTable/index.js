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

const postColumns = [
  {
    title: 'Title',
    render: (rowData) => {
      if (rowData.group_message)
        return rowData.group_message.subject;
      if (rowData.news_link)
        return rowData.news_link.title;
      if (rowData.social_link)
        return rowData.social_link.url;
      return 'None Found';
    },
    query_field: '(CASE '
      + 'WHEN group_message_id IS NOT NULL THEN group_messages.subject '
      + 'WHEN news_link_id IS NOT NULL THEN news_links.title '
      + 'WHEN social_link_id IS NOT NULL THEN social_links.url '
      + 'ELSE null '
      + 'END)',
  },
  {
    title: 'Type',
    render: (rowData) => {
      if (rowData.group_message)
        return intl.formatMessage(messages.group_message);
      if (rowData.news_link)
        return intl.formatMessage(messages.news_link);
      if (rowData.social_link)
        return intl.formatMessage(messages.social_link);
      return intl.formatMessage(messages.error);
    },
    query_field: '(CASE '
      + 'WHEN group_message_id IS NOT NULL THEN 1 '
      + 'WHEN news_link_id IS NOT NULL THEN 2 '
      + 'WHEN social_link_id IS NOT NULL THEN 3 '
      + 'ELSE 4 '
      + 'END)',
  },
];


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

export function PostsTable(props) {
  return (
    <DiverstTable
      title='Archives'
      isLoading={props.isLoading}
      handlePagination={props.handlePagination}
      handleOrdering={props.handleOrdering}
      rowsPerPage={10}
      dataArray={Object.values(props.archives)}
      dataTotal={props.archivesTotal}
      columns={postColumns}
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

PostsTable.propTypes = {
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
)(PostsTable);

