/**
 *
 * FieldsPage
 *
 *  - lists all enterprise custom fields
 *  - renders forms for creating & editing custom fields
 *
 *  - function:
 *    - get fields from server
 *    - on edit - render respective form with field data
 *    - on new - render respective empty form
 *    - on save - create/update field
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
import NotFoundPage from 'containers/Shared/NotFoundPage';

export function FieldListPage(props) {
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
      <NotFoundPage
        updates={props.updates}
        total={props.total}
        isFetching={props.isFetching}

        handlePagination={handlePagination}

        currentGroup={props.currentGroup}

        numberField
      />
    </React.Fragment>
  );
}

FieldListPage.propTypes = {
  getUpdatesBegin: PropTypes.func.isRequired,
  deleteUpdateBegin: PropTypes.func,
  updatesUnmount: PropTypes.func.isRequired,

  updates: PropTypes.object,
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
)(FieldListPage);
