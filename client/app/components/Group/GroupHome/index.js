/**
 *
 * Group Home Component
 *
 */

import React, { memo } from 'react';
import PropTypes from 'prop-types';
import { compose } from 'redux';

import { Button, Divider, Typography, Card, Paper, CardContent, Link, Box } from '@material-ui/core';
import DiverstImg from 'components/Shared/DiverstImg';
import EventsPage from 'containers/Event/EventsPage';
import NewsPage from 'containers/News/NewsFeedPage';

import AddIcon from '@material-ui/icons/Add';
import RemoveIcon from '@material-ui/icons/Remove';
import { DiverstCSSGrid, DiverstCSSCell } from 'components/Shared/DiverstCSSGrid';
import { withStyles } from '@material-ui/core/styles';
import EventsList from 'components/Group/GroupHome/GroupHomeEventsList';
import NewsFeed from 'components/Group/GroupHome/GroupHomeNewsList';
import { ROUTES } from 'containers/Shared/Routes/constants';

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

  const joinBtn = (
    props.currentGroup.current_user_is_member
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
          }}
          startIcon={<RemoveIcon />}
        >
          Leave
        </Button>
      )
      : (
        <Button
          variant='contained'
          size='large'
          fullWidth
          color='primary'
          onClick={() => {
            props.joinGroup({
              group_id: props.currentGroup.id
            });
          }}
          startIcon={<AddIcon />}
        >
          Join
        </Button>
      )
  );

  const family = (
    (props.currentGroup.parent || props.currentGroup.children.length > 0) && (
      <Card>
        <CardContent>
          { props.currentGroup.parent && (
            <React.Fragment>
              <Typography variant='h6'>
              Parent-Group
              </Typography>
              <Link
                href={ROUTES.group.home.path(props.currentGroup.parent.id)}
                rel='noopener'
              >
                <Typography>
                  {`${props.currentGroup.parent.name}`}
                </Typography>
              </Link>
              <Typography>
                {`${props.currentGroup.parent.current_user_is_member
                  ? '(are a member)' : '(are not a member)'}`}
              </Typography>
            </React.Fragment>
          )}
          { props.currentGroup.children.length > 0 && (
            <React.Fragment>
              <Typography variant='h6'>
              Sub-Groups
              </Typography>
              {props.currentGroup.children.map(child => (
                <React.Fragment key={`child:${child.id}`}>
                  <Box mb={1} />
                  <Divider />
                  <Box mb={1} />
                  <Link
                    href={ROUTES.group.home.path(child.id)}
                    rel='noopener'
                  >
                    <Typography>
                      {`${child.name}`}
                    </Typography>
                  </Link>
                  <Typography>
                    {`${child.current_user_is_member
                      ? '(are a member)' : '(are not a member)'}`}
                  </Typography>
                </React.Fragment>
              ))}
            </React.Fragment>
          )}
        </CardContent>
      </Card>
    )
  );

  return (
    <DiverstCSSGrid
      columns={10}
      rows='auto 50px 50px 1fr'
      areas={[
        'header header  header  header  header  header  header  header  header  header',
        'news   news    news    news    events  events  events  events  join    join',
        'news   news    news    news    events  events  events  events  family  family',
        'news   news    news    news    events  events  events  events  null    null',
      ]}
      rowGap='16px'
      columnGap='24px'
    >
      <DiverstCSSCell area='header'>{groupImage}</DiverstCSSCell>
      <DiverstCSSCell area='news'>{news}</DiverstCSSCell>
      <DiverstCSSCell area='events'>{events}</DiverstCSSCell>
      <DiverstCSSCell area='family'>{family}</DiverstCSSCell>
      <DiverstCSSCell area='join'>{joinBtn}</DiverstCSSCell>
      <DiverstCSSCell area='null'><React.Fragment /></DiverstCSSCell>
    </DiverstCSSGrid>
  );
}

GroupHome.propTypes = {
  currentGroup: PropTypes.object,
  classes: PropTypes.object,
  joinGroup: PropTypes.func,
  leaveGroup: PropTypes.func,
};

export default compose(
  memo,
  withStyles(styles)
)(GroupHome);
