import React, { memo, useEffect, useContext, useState } from 'react';
import PropTypes from 'prop-types';
import { compose } from 'redux';
import DiverstTable from 'components/Shared/DiverstTable';
import { injectIntl, intlShape } from 'react-intl';
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

export function PostsTable(props) {
  const { intl } = props;
  const columns = [
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
        + 'WHEN group_message_id IS NOT NULL THEN LOWER(group_messages.subject) '
        + 'WHEN news_link_id IS NOT NULL THEN LOWER(news_links.title) '
        + 'WHEN social_link_id IS NOT NULL THEN LOWER(social_network_posts.url) '
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
  const handleOrderChange = (columnId, orderDir) => {
    props.handleOrdering({
      orderBy: (columnId === -1) ? 'news_feed_links.id' : `${columns[columnId].query_field}`,
      orderDir: (columnId === -1) ? 'asc' : orderDir
    });
  };

  return (
    <DiverstTable
      title='Archives'
      isLoading={props.isLoading}
      handlePagination={props.handlePagination}
      onOrderChange={handleOrderChange}
      rowsPerPage={10}
      dataArray={Object.values(props.archives)}
      dataTotal={props.archivesTotal}
      columns={columns}
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
