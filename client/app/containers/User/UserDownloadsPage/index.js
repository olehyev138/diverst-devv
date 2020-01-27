import React, {
  memo, useContext, useEffect, useState
} from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { createStructuredSelector } from 'reselect';
import { compose } from 'redux';
import { useInjectSaga } from 'utils/injectSaga';
import { useInjectReducer } from 'utils/injectReducer';
import reducer from 'containers/User/reducer';
import saga from 'containers/User/saga';

import {
  selectPaginatedDownloads,
  selectDownloadsTotal,
  selectIsLoadingDownloads,
  selectIsDownloadingData,
  selectDownloadData,
} from 'containers/User/selectors';
import { getUserDownloadsBegin, getUserDownloadDataBegin, userUnmount } from 'containers/User/actions';

import RouteService from 'utils/routeHelpers';

import DownloadsList from 'components/User/DownloadsList';

const defaultParams = Object.freeze({
  count: 10,
  page: 0,
  order: 'desc',
  orderBy: 'created_at',
});

export function UserDownloadsPage(props) {
  useInjectReducer({ key: 'users', reducer });
  useInjectSaga({ key: 'users', saga });

  const rs = new RouteService(useContext);
  const links = {
  };

  const [params, setParams] = useState(defaultParams);

  useEffect(() => {
    props.getUserDownloadsBegin(params);

    return () => props.userUnmount();
  }, []);

  const handlePagination = (payload) => {
    const newParams = { ...params, count: payload.count, page: payload.page };

    props.getUserDownloadsBegin(newParams);
    setParams(newParams);
  };

  return (
    <DownloadsList
      downloads={props.downloads}
      downloadsTotal={props.downloadsTotal}
      getUserDownloadDataBegin={props.getUserDownloadDataBegin}
      downloadData={props.downloadData}
      isDownloadingData={props.isDownloadingData}
      handlePagination={handlePagination}
      isLoading={props.isLoading}
      links={links}
    />
  );
}

UserDownloadsPage.propTypes = {
  getUserDownloadsBegin: PropTypes.func.isRequired,
  getUserDownloadDataBegin: PropTypes.func.isRequired,
  userUnmount: PropTypes.func.isRequired,
  downloads: PropTypes.array,
  downloadsTotal: PropTypes.number,
  downloadData: PropTypes.object,
  isLoading: PropTypes.bool,
  isDownloadingData: PropTypes.bool,
  currentGroup: PropTypes.shape({
    id: PropTypes.number,
  }),
};

const mapStateToProps = createStructuredSelector({
  downloads: selectPaginatedDownloads(),
  downloadsTotal: selectDownloadsTotal(),
  isLoading: selectIsLoadingDownloads(),
  isDownloadingData: selectIsDownloadingData(),
  downloadData: selectDownloadData(),
});

const mapDispatchToProps = {
  getUserDownloadsBegin,
  getUserDownloadDataBegin,
  userUnmount,
};

const withConnect = connect(
  mapStateToProps,
  mapDispatchToProps,
);

export default compose(
  withConnect,
  memo,
)(UserDownloadsPage);
