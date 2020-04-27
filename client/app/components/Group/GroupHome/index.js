/**
 *
 * Group Home Component
 *
 */

import React, { memo, useState } from 'react';
import PropTypes from 'prop-types';
import { compose } from 'redux';

import { Button, Divider, Typography, Card, Paper, CardContent, Link, Box, CardHeader } from '@material-ui/core';

import DiverstImg from 'components/Shared/DiverstImg';
import EventsPage from 'containers/Event/EventsPage';
import NewsPage from 'containers/News/NewsFeedPage';
import SponsorCard from 'components/Branding/Sponsor/SponsorCard';

import AddIcon from '@material-ui/icons/Add';
import RemoveIcon from '@material-ui/icons/Remove';
import { DiverstCSSGrid, DiverstCSSCell } from 'components/Shared/DiverstCSSGrid';
import { withStyles } from '@material-ui/core/styles';
import EventsList from 'components/Event/HomeEventsList';
import NewsFeed from 'components/News/HomeNewsList';
import { ROUTES } from 'containers/Shared/Routes/constants';
import GroupHomeFamily from 'components/Group/GroupHome/GroupHomeFamily';
import DiverstDialog from 'components/Shared/DiverstDialog';
import SubgroupJoinForm from 'components/Group/GroupHome/SubgroupJoinForm';

const styles = theme => ({
  title: {
    textAlign: 'center',
    fontWeight: 'bold',
    paddingBottom: theme.spacing(1),
  },
  dataHeaders: {
    paddingBottom: theme.spacing(1),
  },
});

export function GroupHome({ classes, ...props }) {
  const groupImage = props.currentGroup.banner_data && (
    <DiverstImg
      data={props.currentGroup.banner_data}
      alt=''
      maxWidth='100%'
      minWidth='100%'
    />
  );

  const events = (
    <Paper>
      <CardContent>
        <Typography variant='h5' className={classes.title}>
          Upcoming Events
        </Typography>
        <EventsPage
          currentGroup={props.currentGroup}
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
          Latest News
        </Typography>
        <NewsPage
          currentGroup={props.currentGroup}
          listComponent={NewsFeed}
          readonly
        />
      </CardContent>
    </Paper>
  );
  const [openSubgroup, setOpenSubgroup] = useState(false);
  const [isJoined, setIsJoined] = useState(props.currentGroup.current_user_is_member);

  const handleOpenSubgroup = () => {
    setOpenSubgroup(true);
  };

  const handleClose = () => {
    setOpenSubgroup(false);
    setIsJoined(!isJoined);
  };
  const handleJoinParentGroup = () => {
    props.joinSubgroups({
      group_id: props.currentGroup.parent_id,
      subgroups: [{ group_id: props.currentGroup.id, join: true }]
    });
    handleClose();
  };
  const handleJoinGroup = () => {
    props.joinGroup({
      group_id: props.currentGroup.id
    });
    handleClose();
  }

  const joinBtn = (
    isJoined
      ? (
        <Button
          variant='contained'
          size='large'
          fullWidth
          color='secondary'
          onClick={() => {
            props.leaveGroup({
              group_id: props.currentGroup.id
            });
            setIsJoined(!isJoined);
          }}
          startIcon={<RemoveIcon />}
        >
          Leave
        </Button>
      )
      : (
        <div>
          <Button
            variant='contained'
            size='large'
            fullWidth
            color='primary'
            onClick={(handleOpenSubgroup)}
            startIcon={<AddIcon />}
          >
            Join
          </Button>
          {props.currentGroup.parent_id === null
            ? (
              <DiverstDialog
                open={openSubgroup}
                title='Thanks for joining the group! '
                content={(
                  <SubgroupJoinForm
                    subgroupJoinAction={props.joinSubgroups}
                    handleClose={handleClose}
                    handleCancel={handleJoinGroup}
                    group={props.currentGroup}
                  />
                )}
              />
            )
            : (
              <DiverstDialog
                open={openSubgroup}
                title='Thanks for joining the group! '
                content='Do you want to also join the parent group?'
                handleYes={handleJoinParentGroup}
                textYes='Yes'
                handleNo={handleJoinGroup}
                textNo='No'
              />
            )
          }
        </div>
      )
  );

  const family = (
    <GroupHomeFamily
      {...props}
    />
  );

  const sponsor = (
    <SponsorCard
      type='group'
      currentGroup={props.currentGroup}
    />
  );

  return (
    <DiverstCSSGrid
      columns={10}
      rows='auto auto auto 1fr'
      areas={[
        'header header  header  header  header  header  header  header  header  header',
        'news   news    news    news    events  events  events  events  join    join',
        'news   news    news    news    events  events  events  events  sponsor sponsor',
        'news   news    news    news    events  events  events  events  family  family',
      ]}
      rowGap='16px'
      columnGap='24px'
    >
      <DiverstCSSCell area='header'>{groupImage}</DiverstCSSCell>
      <DiverstCSSCell area='news'>{news}</DiverstCSSCell>
      <DiverstCSSCell area='events'>{events}</DiverstCSSCell>
      <DiverstCSSCell area='family'>{family}</DiverstCSSCell>
      <DiverstCSSCell area='join'>{joinBtn}</DiverstCSSCell>
      <DiverstCSSCell area='sponsor'>{sponsor}</DiverstCSSCell>
      <DiverstCSSCell area='null'><React.Fragment /></DiverstCSSCell>
    </DiverstCSSGrid>
  );
}

GroupHome.propTypes = {
  currentGroup: PropTypes.object,
  classes: PropTypes.object,
  joinGroup: PropTypes.func,
  leaveGroup: PropTypes.func,
  joinSubgroups: PropTypes.func,
};

export default compose(
  memo,
  withStyles(styles)
)(GroupHome);
