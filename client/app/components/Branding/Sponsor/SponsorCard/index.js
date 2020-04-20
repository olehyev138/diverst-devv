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
import { connect } from 'react-redux';
import { createStructuredSelector } from 'reselect';


const SponsorType = Object.freeze({
  Group: 'group',
  Enterprise: 'enterprise',
});

export function SponsorCard(props) {
  useInjectReducer({ key: 'sponsors', reducer });
  useInjectSaga({ key: 'sponsors', saga });

  const sponsorParams = {
    orderBy: '', order: 'asc', query_scopes: ['group_sponsor'], sponsorable_id: props.currentGroup ? props.currentGroup.id : 0
  };
  const enterpriseParams = {
    orderBy: '', order: 'asc', query_scopes: ['enterprise_sponsor']
  };

  const { sponsorList } = props;

  useEffect(() => {
    if (props.type === SponsorType.Group)
      props.getSponsorsBegin(sponsorType);
    else
      props.getSponsorsBegin(enterpriseParams);
  }, []);

  if (props.sponsorTotal > 1)
    return (
      <Carousel
        autoPlay={false}
      >
        {sponsorList.map(sponsor => (
          <Card key={sponsor.id}>
            <CardContent>
              <Typography variant='h6'>
                { sponsor.sponsor_name}
              </Typography>
              <Typography>
                { sponsor.sponsor_title}
              </Typography>
            </CardContent>
            <CardContent>
              { sponsor.sponsor_message}
            </CardContent>
          </Card>
        ))}
      </Carousel>
    );
  if (sponsorList[0])
    return (
      <Card>
        <CardContent>
          <Typography variant='h6'>
            { sponsorList[0].sponsor_name}
          </Typography>
          <Typography>
            { sponsorList[0].sponsor_title}
          </Typography>
        </CardContent>
        <CardContent>
          { sponsorList[0].sponsor_message}
        </CardContent>
      </Card>
    );
  return (
    <React.Fragment>

    </React.Fragment>
  );
}

SponsorCard.propTypes = {
  getSponsorsBegin: PropTypes.func,
  type: PropTypes.string,
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
