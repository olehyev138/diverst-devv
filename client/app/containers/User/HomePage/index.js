/**
 *
 * HomePage
 *
 */

import React, { memo } from 'react';
import PropTypes from 'prop-types';
import { compose } from 'redux';
import { connect } from 'react-redux';
import { createStructuredSelector } from 'reselect';

import messages from './messages';

import Events from '../UserEventsPage';
import News from '../UserNewsFeedPage';
import SponsorCard from 'components/Branding/Sponsor/SponsorCard';

import {
  Typography, Button, Grid, Card, CardActions, CardContent, Paper, Divider
} from '@material-ui/core';
import { withStyles } from '@material-ui/core/styles';

import DiverstFormattedMessage from 'components/Shared/DiverstFormattedMessage';
import DiverstDialog from 'components/Shared/DiverstDialog';
import EventsList from 'components/Event/HomeEventsList';
import NewsFeed from 'components/News/HomeNewsList';

import { injectIntl, intlShape } from 'react-intl';
import { selectEnterprisePrivacyMessage, selectEnterprise } from 'containers/Shared/App/selectors';
import DiverstHTMLEmbedder from 'components/Shared/DiverstHTMLEmbedder';

const styles = theme => ({
  title: {
    textAlign: 'center',
    fontWeight: 'bold',
    paddingBottom: theme.spacing(1),
  },
  dataHeaders: {
    paddingBottom: theme.spacing(1),
  },
  privacyStatement: {
    padding: theme.spacing(1),
    textDecoration: 'underline',
  }
});

/* eslint-disable react/prefer-stateless-function */
export class HomePage extends React.PureComponent {
  constructor(props) {
    super(props);
    this.state = {
      open: false
    };
  }

handleClickOpen = () => {
  this.setState({ open: true });
};

  handleClose = () => {
    this.setState({ open: false });
  };


  render() {
    const { classes } = this.props;
    const events = (
      <Paper>
        <CardContent>
          <Typography variant='h5' className={classes.title}>
            <DiverstFormattedMessage {...messages.events} />
          </Typography>
          <Events
            listComponent={EventsList}
            readonly
            loaderProps={{
              transitionProps: {
                direction: 'right',
              },
            }}
          />
        </CardContent>
      </Paper>
    );

    const news = (
      <Paper>
        <CardContent>
          <Typography variant='h5' className={classes.title}>
            <DiverstFormattedMessage {...messages.news} />
          </Typography>
          <News
            listComponent={NewsFeed}
            readonly
          />
        </CardContent>
      </Paper>
    );

    const privacyMessage = (
      <React.Fragment>
        <Typography onClick={this.handleClickOpen} className={classes.privacyStatement} color='primary'>
          <DiverstFormattedMessage {...messages.privacy} />
        </Typography>
        <DiverstDialog
          open={this.state.open}
          handleNo={this.handleClose}
          textNo={this.props.intl ? this.props.intl.formatMessage(messages.close) : ' '}
          content={this.props.privacyMessage}
          title={this.props.intl ? this.props.intl.formatMessage(messages.privacy) : ' '}
        />
      </React.Fragment>
    );

    const sponsor = (
      <SponsorCard
        type='enterprise'
        currentGroup={null}
      />
    );

    const enterpriseMessage = (
      <DiverstHTMLEmbedder
        html={
          this.props.enterprise
            ? this.props.enterprise.home_message
            : ''
        }
      />
    );

    return (
      <React.Fragment>
        <Grid container spacing={3} direction='column'>
          <Grid item>
            {enterpriseMessage}
          </Grid>
          <Grid item>
            <Grid container spacing={3}>
              <Grid item xs>
                {events}
              </Grid>
              <Grid item xs>
                {news}
              </Grid>
            </Grid>
          </Grid>
          <Grid item xs>
            {sponsor}
          </Grid>
          <Grid item xs>
            {privacyMessage}
          </Grid>
        </Grid>
      </React.Fragment>
    );
  }
}

const mapDispatchToProps = {
};

const mapStateToProps = createStructuredSelector({
  privacyMessage: selectEnterprisePrivacyMessage(),
});

const withConnect = connect(
  mapStateToProps,
  mapDispatchToProps,
);

HomePage.propTypes = {
  classes: PropTypes.object,
  privacyMessage: PropTypes.string,
  intl: intlShape,
};

export default compose(
  withConnect,
  memo,
  injectIntl,
  withStyles(styles),
)(HomePage);
