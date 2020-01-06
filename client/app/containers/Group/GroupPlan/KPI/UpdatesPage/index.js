/**
 *
 * UpdatesPage
 *
 *  - lists all enterprise custom updates
 *  - renders forms for creating & editing custom updates
 *
 *  - function:
 *    - get updates from server
 *    - on edit - render respective form with update data
 *    - on new - render respective empty form
 *    - on save - create/update update
 */

import React, { memo, useEffect, useState } from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import dig from 'object-dig';

import { createStructuredSelector } from 'reselect/lib';
import { compose } from 'redux';

import { useInjectSaga } from 'utils/injectSaga';
import { useInjectReducer } from 'utils/injectReducer';

import {
  selectPaginatedUpdates,
  selectUpdatesTotal,
  selectIsFetchingUpdates,
  selectHasChanged,
} from 'containers/Shared/Update/selectors';
import {
  getUpdatesBegin,
  deleteUpdateBegin,
  updatesUnmount,
} from 'containers/Shared/Update/actions';

import reducer from 'containers/Shared/Update/reducer';
import saga from '../updatesSaga';

import { selectGroup } from 'containers/Group/selectors';
import UpdateList from 'components/Shared/Updates/UpdateList';

export function UpdateListPage(props) {
  useInjectReducer({ key: 'updates', reducer });
  useInjectSaga({ key: 'updates', saga });

  const [params, setParams] = useState(
    {
      count: 5,
      page: 0,
      order: 'asc',
      orderBy: 'id',
      groupId: dig(props, 'currentGroup', 'id'),
    }
  );

  useEffect(() => {
    props.getUpdatesBegin(params);

    return () => {
      props.updatesUnmount();
    };
  }, []);

  useEffect(() => {
    if (props.hasChanged)
      props.getUpdatesBegin(params);

    return () => {
      props.updatesUnmount();
    };
  }, [props.hasChanged]);

  const handlePagination = (payload) => {
    const newParams = { ...params, count: payload.count, page: payload.page };

    props.getUpdatesBegin(newParams);
    setParams(newParams);
  };

  return (
    <React.Fragment>
      <UpdateList
        updates={props.updates}
        updateTotal={props.total}
        isFetching={props.isFetching}

        handlePagination={handlePagination}

        currentGroup={props.currentGroup}
      />
    </React.Fragment>
  );
}

UpdateListPage.propTypes = {
  getUpdatesBegin: PropTypes.func.isRequired,
  deleteUpdateBegin: PropTypes.func,
  updatesUnmount: PropTypes.func.isRequired,

  updates: PropTypes.array,
  total: PropTypes.number,
  isFetching: PropTypes.bool,
  hasChanged: PropTypes.bool,

  currentGroup: PropTypes.shape({
    id: PropTypes.number
  })
};

const mapStateToProps = createStructuredSelector({
  updates: selectPaginatedUpdates(),
  total: selectUpdatesTotal(),
  isFetching: selectIsFetchingUpdates(),
  hasChanged: selectHasChanged(),
  currentGroup: selectGroup(),
});

const mapDispatchToProps = {
  getUpdatesBegin,
  deleteUpdateBegin,
  updatesUnmount,
};

const withConnect = connect(
  mapStateToProps,
  mapDispatchToProps,
);

export default compose(
  withConnect,
  memo,
)(UpdateListPage);
