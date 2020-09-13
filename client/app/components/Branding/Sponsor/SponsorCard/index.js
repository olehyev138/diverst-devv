/**
 *
 * Sponsor Card component
 * A carousel containing cards of sponsors
 */

import React, { memo, useEffect, useState } from 'react';
import PropTypes from 'prop-types';
import { compose } from 'redux';

import { Button, Divider, Typography, Card, Paper, CardContent, Link, Box, CardHeader, Grid, Hidden } from '@material-ui/core';
import Carousel from 'react-material-ui-carousel';

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
import DiverstImg from 'components/Shared/DiverstImg';

const SponsorType = Object.freeze({
  Group: 'group',
  Enterprise: 'enterprise',
});

export function SponsorCard(props) {
  useInjectReducer({ key: 'sponsors', reducer });
  useInjectSaga({ key: 'sponsors', saga });

  const { sponsorList } = props;

  useEffect(() => {
    if (!props.noAsync)
      if (props.type === SponsorType.Group)
        props.getSponsorsBegin({
          orderBy: '', order: 'asc', query_scopes: ['group_sponsor'], sponsorable_id: props.currentGroup.id
        });
      else
        props.getSponsorsBegin({
          orderBy: '', order: 'asc', query_scopes: ['enterprise_sponsor']
        });
  }, []);

  const individualSponsor = sponsor => (
    <Card key={sponsor.id}>
      <CardContent>
        <Grid container spacing={2} direction='column'>
          {sponsor.sponsor_media_data && (
            <React.Fragment>
              <Hidden xsDown>
                <Grid item xs={12}>
                  <DiverstImg
                    data={sponsor.sponsor_media_data}
                    contentType={sponsor.sponsor_media_content_type}
                    maxWidth='100%'
                    maxHeight='100px'
                    height='auto'
                  />
                </Grid>
              </Hidden>
            </React.Fragment>
          )}
          <Grid item>
            <Typography variant='h6'>
              {sponsor.sponsor_name}
            </Typography>
            <Typography>
              {sponsor.sponsor_title}
            </Typography>
          </Grid>
        </Grid>
      </CardContent>
      <CardContent>
        { sponsor.sponsor_message}
      </CardContent>
    </Card>
  );

  if (props.sponsorTotal > 1 && !props.single)
    return (
      <Carousel
        autoPlay={false}
      >
        {sponsorList.map(individualSponsor)}
      </Carousel>
    );

  if (props.sponsor || props.sponsorTotal >= 1)
    return individualSponsor(props.sponsor || props.sponsorList[0]);

  return (
    <React.Fragment />
  );
}

SponsorCard.propTypes = {
  getSponsorsBegin: PropTypes.func,
  type: PropTypes.string,
  currentGroup: PropTypes.object,
  sponsorList: PropTypes.array,
  sponsorTotal: PropTypes.number,
  sponsor: PropTypes.object,
  single: PropTypes.bool,
  noAsync: PropTypes.bool,
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
)(SponsorCard);