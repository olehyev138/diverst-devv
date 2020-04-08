/**
 *
 * Sponsor Card component
 * A carousel containing cards of sponsors
 */

import React, { memo, useEffect, useState } from 'react';
import PropTypes from 'prop-types';
import { compose } from 'redux';

import { Button, Divider, Typography, Card, Paper, CardContent, Link, Box, CardHeader } from '@material-ui/core';
import Carousel from 'react-material-ui-carousel';
import { injectIntl } from 'react-intl';

import {
  getSponsorsBegin, deleteSponsorBegin,
  sponsorsUnmount
} from 'containers/Shared/Sponsors/actions';

import {
  selectSponsors, selectSponsorTotal,
  selectIsFetchingSponsors, selectPaginatedSponsors
} from 'containers/Shared/Sponsors/selectors';

import { useInjectSaga } from 'utils/injectSaga';
import { useInjectReducer } from 'utils/injectReducer';
import saga from 'containers/Shared/Sponsors/saga';
import reducer from 'containers/Shared/Sponsors/reducer';
import { push } from 'connected-react-router';
import { connect } from 'react-redux';
import { createStructuredSelector } from 'reselect';


export function SponsorCard(props) {
  useInjectReducer({ key: 'sponsors', reducer });
  useInjectSaga({ key: 'sponsors', saga });

  const SponsorType = Object.freeze({
    Group: 'group',
    Enterprise: 'enterprise',
  });

  const groupParams = {
    orderBy: '', order: 'asc', query_scopes: ['group_sponsor'], sponsorable_id: props.currentGroup.id
  };
  const enterpriseParams = {
    orderBy: '', order: 'asc',
  };

  useEffect(() => {
    if (props.type === SponsorType.Group)
      props.getSponsorsBegin(groupParams);
    else
      props.getSponsorsBegin(enterpriseParams);
  }, []);

  console.log(props.sponsorList);
  return (
    props.sponsorTotal > 1 ? (
      <Carousel
        autoPlay={false}
      >
        {props.sponsorList.map((sponsor) => (
          <Card>
            <CardContent>
              { sponsor.sponsor_name}
            </CardContent>
            <CardContent>
              { sponsor.sponsor_message}
            </CardContent>
          </Card>
        ))}
      </Carousel>
    )
      : (
        <Card>
        </Card>
      )
  );
}

SponsorCard.propTypes = {
  getSponsorsBegin: PropTypes.func,
  type: PropTypes.func,
  currentGroup: PropTypes.object,
  sponsorList: PropTypes.array,
  sponsorTotal: PropTypes.number,
};

const mapStateToProps = createStructuredSelector({
  sponsorList: selectSponsors(),
  sponsorTotal: selectSponsorTotal(),
  isFetchingSponsors: selectIsFetchingSponsors(),
});

const mapDispatchToProps = dispatch => ({
  getSponsorsBegin: payload => dispatch(getSponsorsBegin(payload))
});

const withConnect = connect(
  mapStateToProps,
  mapDispatchToProps,
);

export default compose(
  memo,
  withConnect,
  injectIntl,
)(SponsorCard);
