import { UserWithFollowInfo } from "@dogehouse/kebab";
import React from "react";
import { SolidFriends } from "../../icons";
import { useConn } from "../../shared-hooks/useConn";
import { useTypeSafeMutation } from "../../shared-hooks/useTypeSafeMutation";
import { useTypeSafeTranslation } from "../../shared-hooks/useTypeSafeTranslation";
import { useTypeSafeUpdateQuery } from "../../shared-hooks/useTypeSafeUpdateQuery";
import { Button } from "../../ui/Button";
import { VerticalUserInfo } from "../../ui/VerticalUserInfo";

interface VerticalUserInfoControllerProps {
  user: UserWithFollowInfo;
  idOrUsernameUsedForQuery: string;
}

export const VerticalUserInfoWithFollowButton: React.FC<VerticalUserInfoControllerProps> = ({
  idOrUsernameUsedForQuery,
  user,
}) => {
  const { mutateAsync, isLoading: followLoading } = useTypeSafeMutation(
    "follow"
  );
  const conn = useConn();
  const updater = useTypeSafeUpdateQuery();
  const { t } = useTypeSafeTranslation();

  return (
    <>
      <VerticalUserInfo user={user} />
      <div className={`mb-2 items-center w-full justify-center`}>
        {/* @todo add real icon */}
        {user.id !== conn.user.id ? (
          <Button
            loading={followLoading}
            onClick={async () => {
              await mutateAsync([user.id, !user.youAreFollowing]);
              updater(["getUserProfile", idOrUsernameUsedForQuery], (u) =>
                !u
                  ? u
                  : {
                      ...u,
                      numFollowers:
                        u.numFollowers + (user.youAreFollowing ? -1 : 1),
                      youAreFollowing: !user.youAreFollowing,
                    }
              );
            }}
            size="small"
            icon={<SolidFriends />}
          >
            {user.youAreFollowing
              ? t("pages.viewUser.unfollow")
              : t("pages.viewUser.followHim")}
          </Button>
        ) : null}
      </div>
    </>
  );
};
